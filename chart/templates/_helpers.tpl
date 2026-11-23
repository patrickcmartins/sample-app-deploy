{{- define "app.name" -}}sample-app{{- end }}

{{- define "app.labels" -}}
app.kubernetes.io/name: {{ include "app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end }}

{{- define "app.selector" -}}
app.kubernetes.io/name: {{ include "app.name" . }}
{{- end }}

{{- define "app.host" -}}
{{ include "app.name" . }}.{{ .Release.Namespace }}.svc.cluster.local
{{- end }}

{{- define "app.principal" -}}
cluster.local/ns/{{ .ctx.Release.Namespace }}/sa/{{ .sa }}
{{- end }}

{{/* Env comum: identidade OTel e destino da telemetria. */}}
{{- define "app.otelEnv" -}}
{{- if .ctx.Values.otel.enabled }}
- { name: OTEL_EXPORTER_OTLP_ENDPOINT, value: {{ .ctx.Values.otel.endpoint | quote }} }
- { name: OTEL_SERVICE_NAME, value: {{ .service | quote }} }
- { name: OTEL_RESOURCE_ATTRIBUTES, value: "deployment.environment={{ .ctx.Values.environment }},service.version={{ .tag }}" }
{{- end }}
{{- end }}

{{/* Segurança de pod e container comum a todos os componentes do app. */}}
{{- define "app.podSecurity" -}}
automountServiceAccountToken: false
securityContext:
  runAsNonRoot: true
  runAsUser: 65532
  runAsGroup: 65532
  seccompProfile: { type: RuntimeDefault }
{{- end }}

{{- define "app.containerSecurity" -}}
securityContext:
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities: { drop: ["ALL"] }
{{- end }}
