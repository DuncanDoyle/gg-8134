# Use Case


__Original Ticket description:__ Support RouteTable delegation where the RT path is more general than the parent VS Route path 

Example:

```
VS1
domain: foo.com
path: /
name: slash

VS2
domains: bar.com
path /bar
name: bar

Shared RT:
path: /
name: slash

path:/bar
name: bar
```

The actual paths that need to be served are:

```
domain: foo.com
path: /

domain: bar.com
path: /bar
```

This use-case is solvable by using relative matchers in the child/shared RT. So you would end up with:

```
VS1
domain: foo.com
parth: /

VS2
domain: bar.com
path: /bar

Shared RT:
relativeMatcher: true
path: /
```

This way, the final matcher will be a concatenation of the matcher in the parent and child:

```
domain: foo.com
path: /

domain: bar.com
path: /bar/
```

Which satisfies the requirement.

Second, this is the matching logic that is available in Gloo Mesh Gateway, and the logic that can be used (using the annotation `delegation.gateway.solo.io/inherit-parent-matcher: "true"` ) in our Gloo Gateway K8S Gateway API implementation.
