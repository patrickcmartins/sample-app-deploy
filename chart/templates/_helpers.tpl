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
