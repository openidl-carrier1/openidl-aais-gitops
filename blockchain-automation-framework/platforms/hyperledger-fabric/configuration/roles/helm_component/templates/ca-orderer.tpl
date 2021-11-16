apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}-ca
  namespace: {{ component_name }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}-ca
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/ca    
  values:
{% if network.env.annotations is defined %}
    deployment:
      annotations:
{% for item in network.env.annotations.deployment %}
{% for key, value in item.items() %}
        - {{ key }}: {{ value | quote }}
{% endfor %}
{% endfor %}
    annotations:  
      service:
{% for item in network.env.annotations.service %}
{% for key, value in item.items() %}
        - {{ key }}: {{ value | quote }}
{% endfor %}
{% endfor %}
      pvc:
{% for item in network.env.annotations.pvc %}
{% for key, value in item.items() %}
        - {{ key }}: {{ value | quote }}
{% endfor %}
{% endfor %}
{% endif %}
    metadata:
      namespace: {{ component_name | e }}
      images:
        alpineutils: {{ alpine_image }}
        ca: {{ ca_image }}
    server:
      name: {{ component_services.ca.name }}
      tlsstatus: true
      admin: {{ component }}-admin
    storage:
      storageclassname: {{ component | lower }}sc
      storagesize: 20Gi 
    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ network.env.type }}{{ component_name }}-auth
      secretcert: {{ vault.secret_path | default('secret') }}/crypto/ordererOrganizations/{{ component_name | e }}/ca?ca.{{ component_name | e }}-cert.pem
      secretkey: {{ vault.secret_path | default('secret') }}/crypto/ordererOrganizations/{{ component_name | e }}/ca?{{ component_name | e }}-CA.key
      secretadminpass: {{ vault.secret_path | default('secret') }}/credentials/{{ component_name | e }}/ca/{{ component }}?user
      serviceaccountname: vault-auth
      imagesecretname: regcred
    service:
      servicetype: ClusterIP
      ports:
        tcp:
          port: {{ component_services.ca.grpc.port }}
{% if component_services.ca.grpc.nodePort is defined %}
          nodeport: {{ component_services.ca.grpc.nodePort }}
{% endif %}
    proxy:
      provider: {{ network.env.proxy }}
      type: orderer
      external_url_suffix: {{ external_url_suffix }}
