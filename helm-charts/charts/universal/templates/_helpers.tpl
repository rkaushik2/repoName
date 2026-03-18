{{/*
Expand the name of the chart.
*/}}
{{- define "universal.name" -}}
{{ .Values.appName }}
{{- end }}

{{/*
Common labels applied to all resources.
*/}}
{{- define "universal.labels" -}}
app.kubernetes.io/name: {{ .Values.appName }}
app.kubernetes.io/instance: {{ .Values.appName }}-{{ .Values.environment }}
app.kubernetes.io/managed-by: argocd
platform.io/technology: {{ .Values.technology }}
platform.io/environment: {{ .Values.environment }}
{{- if .Values.extraLabels }}
{{ toYaml .Values.extraLabels }}
{{- end }}
{{- end }}

{{/*
Selector labels for deployments and services.
*/}}
{{- define "universal.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.appName }}
app.kubernetes.io/instance: {{ .Values.appName }}-{{ .Values.environment }}
{{- end }}

{{/*
Resolve the container port. Uses explicit .Values.port if set, otherwise tech default.
*/}}
{{- define "universal.port" -}}
{{- if .Values.port -}}
  {{- .Values.port -}}
{{- else -}}
  {{- $tech := index .Values.techDefaults .Values.technology -}}
  {{- $tech.port -}}
{{- end -}}
{{- end }}

{{/*
Resolve the health check path. Uses explicit value if set, otherwise tech default.
*/}}
{{- define "universal.healthPath" -}}
{{- if .Values.healthCheck.path -}}
  {{- .Values.healthCheck.path -}}
{{- else -}}
  {{- $tech := index .Values.techDefaults .Values.technology -}}
  {{- $tech.healthPath -}}
{{- end -}}
{{- end }}

{{/*
Resolve resource requests/limits. Uses explicit value if set, otherwise tech default.
*/}}
{{- define "universal.resources" -}}
{{- if .Values.resources -}}
  {{- toYaml .Values.resources -}}
{{- else -}}
  {{- $tech := index .Values.techDefaults .Values.technology -}}
  {{- toYaml $tech.resources -}}
{{- end -}}
{{- end }}
