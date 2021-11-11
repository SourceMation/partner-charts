{{/*
Expand the name of the chart.
*/}}
{{- define "k8s-triliovault-operator.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "k8s-triliovault-operator.appName" -}}
{{- printf "%s" .Chart.Name -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "k8s-triliovault-operator.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper TrilioVault Operator image name
*/}}
{{- define "k8s-triliovault-operator.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Validation of the secret of CA bundle if provided
*/}}
{{- define "k8s-triliovault-operator.caBundleValidation" -}}
{{- if .Values.proxySettings.CA_BUNDLE_CONFIGMAP }}
{{- if not (lookup "v1" "ConfigMap" .Release.Namespace .Values.proxySettings.CA_BUNDLE_CONFIGMAP) }}
   {{ fail "Proxy CA bundle proxy is not present in the release namespace" }}
{{- else }}
    {{- $caMap := (lookup "v1" "ConfigMap" .Release.Namespace .Values.proxySettings.CA_BUNDLE_CONFIGMAP).data }}
        {{- if not (get $caMap "ca-bundle.crt") }}
            {{ fail "Proxy CA certificate file key should be ca-bundle.crt" }}
        {{- end }}
{{- end }}
{{- end }}
{{- end -}}
