// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go knative.dev/pkg/apis

package apis

// This is attached to contexts passed to webhook interfaces when
// the receiver being validated is being created.
_#inCreateKey: {}

// This is attached to contexts passed to webhook interfaces when
// the receiver being validated is being deleted.
_#inDeleteKey: {}

// This is attached to contexts passed to webhook interfaces when
// the receiver being validated is being updated.
_#inUpdateKey: {}

// This is attached to contexts passed to webhook interfaces when
// the receiver being validated is being created.
_#userInfoKey: {}

// This is attached to contexts as they are passed down through a resource
// being validated or defaulted to signal the ObjectMeta of the enclosing
// resource.
_#parentMetaKey: {}

// This is attached to contexts as they are passed down through a resource
// being validated or defaulted to signal that we are within a Spec.
_#inSpec: {}

// This is attached to contexts as they are passed down through a resource
// being validated or defaulted to signal that we are within a Status.
_#inStatus: {}

// This is attached to contexts as they are passed down through a resource
// being validated to direct them to disallow deprecated fields.
_#disallowDeprecated: {}

// This is attached to contexts as they are passed down through a resource
// being validated to direct them to allow namespaces (or missing namespace)
// outside the parent (as indicated by WithinParent.
_#allowDifferentNamespace: {}

// This is attached to contexts passed to webhook interfaces when the user
// has requested DryRun mode.
_#isDryRun: {}

// This is attached to contexts passed to webhook interfaces with
// additional context from the HTTP request.
_#httpReq: {}
