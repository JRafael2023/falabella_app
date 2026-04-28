import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const HIGHBOND_ORG_ID = "14954";
const HIGHBOND_BASE_URL = "https://apis.highbond.com/v1";

interface CustomAttribute {
  id: string;
  value: string[];
}

interface IssuePayload {
  project_id: number;
  title: string;
  description: string;
  owner: string;
  recommendation: string;
  deficiency_type: string;
  severity: "ALTO" | "MEDIO" | "BAJO" | "CRÍTICO";
  published: boolean;
  identified_at?: string;
  risk: string;
  scope: string;
  escalation: string;
  cause: string;
  executive_owner: string;
  project_owner: string;
  closed?: boolean;
  custom_attributes?: CustomAttribute[];
}

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const apiToken = Deno.env.get("API_TOKEN_HIGHBOND");
    if (!apiToken) {
      return new Response(
        JSON.stringify({ error: "API_TOKEN_HIGHBOND not configured" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const payload: IssuePayload = await req.json();

    // Validaciones mínimas
    if (!payload.project_id) {
      return new Response(
        JSON.stringify({ error: "project_id is required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }
    if (!payload.title) {
      return new Response(
        JSON.stringify({ error: "title is required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const body: Record<string, unknown> = {
      data: {
        type: "issues",
        attributes: {
          title: payload.title,
          description: payload.description,
          owner: payload.owner,
          recommendation: payload.recommendation,
          deficiency_type: payload.deficiency_type,
          severity: payload.severity,
          published: payload.published ?? false,
          risk: payload.risk,
          scope: payload.scope,
          escalation: payload.escalation,
          cause: payload.cause,
          executive_owner: payload.executive_owner,
          project_owner: payload.project_owner,
          ...(payload.identified_at && { identified_at: payload.identified_at }),
          ...(payload.closed !== undefined && { closed: payload.closed }),
          ...(payload.custom_attributes?.length && {
            custom_attributes: payload.custom_attributes,
          }),
        },
      },
    };

    const url = `${HIGHBOND_BASE_URL}/orgs/${HIGHBOND_ORG_ID}/projects/${payload.project_id}/issues`;

    const response = await fetch(url, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${apiToken}`,
        "Content-Type": "application/vnd.api+json",
      },
      body: JSON.stringify(body),
    });

    const responseData = await response.json();

    if (!response.ok) {
      return new Response(
        JSON.stringify({
          error: "Highbond API error",
          status: response.status,
          details: responseData,
        }),
        {
          status: response.status,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    return new Response(JSON.stringify({ success: true, data: responseData }), {
      status: 201,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(
      JSON.stringify({ error: "Internal error", details: String(err) }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
