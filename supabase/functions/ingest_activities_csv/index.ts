// Upserts "activities" from CSV.
// Accepts either "text/csv" body or JSON with { csv: "<csv_text>" }.
// Expected headers: id,name[,type]
// Uses SERVICE ROLE (backend import task).

import { serviceClient } from "../_shared/admin.ts";
import { readCSV } from "https://deno.land/std@0.224.0/csv/mod.ts";

Deno.serve(async (req) => {
  try {
    if (req.method !== "POST") {
      return new Response("Method not allowed", { status: 405 });
    }

    const ctype = req.headers.get("content-type") ?? "";
    let csvText: string | null = null;

    if (ctype.includes("text/csv")) {
      csvText = await req.text();
    } else if (ctype.includes("application/json")) {
      csvText = (await req.json())?.csv ?? null;
    } else {
      return new Response("Unsupported Content-Type", { status: 415 });
    }

    if (!csvText?.trim()) {
      return new Response("Empty CSV", { status: 400 });
    }

    const rows: Record<string, string>[] = [];
    const reader = await readCSV(new Blob([csvText]).stream(), {
      skipFirstRow: false,
    });

    let headers: string[] | null = null;
    for await (const row of reader) {
      if (!headers) {
        headers = row.map((s) => String(s).trim());
        continue;
      }
      const rec: Record<string, string> = {};
      headers.forEach((h, i) => (rec[h] = String(row[i] ?? "").trim()));
      rows.push(rec);
    }

    if (!headers || !headers.includes("id") || !headers.includes("name")) {
      return new Response(
        "CSV must include headers: id,name[,type]",
        { status: 400 },
      );
    }

    const upserts = rows.map((r) => ({
      id: r.id,
      name: r.name,
      type: r.type?.length ? r.type : null,
    }));

    const supa = serviceClient();
    const { error } = await supa
      .from("activities")
      .upsert(upserts, { onConflict: "id" });

    if (error) throw error;

    return new Response(
      JSON.stringify({ upserted: upserts.length }),
      { headers: { "content-type": "application/json" } },
    );
  } catch (e) {
    return new Response(
      JSON.stringify({ error: String(e) }),
      { status: 500, headers: { "content-type": "application/json" } },
    );
  }
});
