local k = import "k.libsonnet";
local i2l = import 'image2url/image2url.libsonnet';

local namespace = import 'param://namespace';
local appName = import 'param://name';
local image = import 'param://image';
local port = import 'param://port';

k.core.v1.list.new([
  i2l.parts.deployment(namespace, appName, image, port),
  i2l.parts.svc(namespace, appName, port)
])
