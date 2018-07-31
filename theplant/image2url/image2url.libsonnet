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
        type: "LoadBalancer",
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

    deployment(namespace, name, image, port, configmap, replicas=1, labels={app: name}, imagePullSecrets="the-plant-registry")::{
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
