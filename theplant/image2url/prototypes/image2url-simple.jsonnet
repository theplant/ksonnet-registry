// @apiVersion 0.0.1
// @name jp.theplant.pkg.image2url
// @description Deploy a docker image and expose a url.
// @shortDescription Deploy a docker image and expose a url.
// @param namespace string Namespace in which to put the application
// @param name string Name to give to all components.


local k = import "k.libsonnet";
local i2l = import 'theplant/image2url/image2url.libsonnet';

local namespace = import 'param://namespace';
local appName = import 'param://name';
local image = import 'param://image';
local port = import 'param://port';

k.core.v1.list.new([
  i2l.parts.deployment(namespace, appName, image, port),
  i2l.parts.svc(namespace, appName, port)
])
