local k = import "k.libsonnet";
// local deployment = k.extensions.v1beta1.deployment;

{
  parts::{
    svc(namespace, name, port, selector={app: name}):: {
      apiVersion: "v1",
      kind: "Service",
      metadata: {
        name: name,
        namespace: namespace,
        labels: {
          app: name
        },
      },
      spec: {
        type: "ClusterIP",
        ports: [
          {
            name: "app",
            port: port,
            targetPort: port,
          },
        ],
        selector: selector
      },
    },

    ingress(namespace, name, port, host, path="/"):: {
        apiVersion: "extensions/v1beta1",
        kind: "Ingress",
        metadata: {
            name: name,
            namespace: namespace,
            annotations: {
                "nginx.ingress.kubernetes.io/rewrite-target": "/",
            },
            labels: {
                app: name
            },
        },
        spec: {
            rules: [
                {
                    host: host,
                    http: {
                        paths: [
                            {
                                path: path,
                                backend: {
                                    serviceName: name,
                                    servicePort: port,
                                },
                            },
                        ],
                    },
                },
            ],
        },
    },

    deployment(namespace, name, image, port, configmap, replicas, imagePullSecrets)::{
      local labels={app: name},
      apiVersion: "extensions/v1beta1",
      kind: "Deployment",
      metadata: {
        namespace: namespace,
        name: name,
        labels: labels
      },
      spec: {
        replicas: replicas,
        template: {
          metadata: {
            labels: labels
          },
          spec: {
            imagePullSecrets: [
                {
                    name: imagePullSecrets,
                },
            ],
            containers: [
              {
                name: name,
                image: image,
                imagePullPolicy: "IfNotPresent",
                envFrom: [
                    {
                        configMapRef: {
                            name: configmap,
                        },
                    },
                ],
                ports: [
                  {
                    name: "app",
                    containerPort: port,
                  },
                ],
                livenessProbe: {
                  tcpSocket: {
                    port: port,
                  },
                  initialDelaySeconds: 5,
                  periodSeconds: 10,
                },
                readinessProbe: {
                  tcpSocket: {
                    port: port,
                  },
                  initialDelaySeconds: 5,
                  periodSeconds: 10,
                },
                resources: {
                    limits: {
                        cpu: "500m",
                        memory: "100Mi",
                    },
                    requests: {
                        cpu: "10m",
                        memory: "10Mi",
                    },
                },
              },
            ],
          },
        },
      },
    },
  },
}
