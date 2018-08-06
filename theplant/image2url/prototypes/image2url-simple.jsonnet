// @apiVersion 0.0.1
// @name jp.theplant.pkg.image2url
// @description Deploy a docker image and expose a url.
// @shortDescription Deploy a docker image and expose a url.
// @param name string Name to give to all components.
// @param image string image.
// @param configmap string configmap of container.
// @param domain string domain host for ingress.
// @optionalParam namespace string default Namespace in which to put the application
// @optionalParam port number 4000 port of container.
// @optionalParam path string / path for ingress.
// @optionalParam replicas number 1 replicas of pods.
// @optionalParam imagePullSecrets string the-plant-registry secrets for pulling docker images.


local k = import "k.libsonnet";
local i2l = import 'theplant/image2url/image2url.libsonnet';

local namespace = import 'param://namespace';
local appName = import 'param://name';
local image = import 'param://image';
local port = import 'param://port';
local configmap = import 'param://configmap';
local domain = import 'param://domain';
local path = import 'param://path';
local replicas = import 'param://replicas';
local imagePullSecrets = import 'param://imagePullSecrets';

k.core.v1.list.new([
  i2l.parts.deployment(namespace, appName, image, port, configmap, replicas, imagePullSecrets),
  i2l.parts.svc(namespace, appName, port),
  i2l.parts.ingress(namespace, appName, port, domain, path),
])
