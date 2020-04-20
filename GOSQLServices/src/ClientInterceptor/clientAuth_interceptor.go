package ClientInterceptor

import (
	"context"
	"log"

	"google.golang.org/grpc"
	"google.golang.org/grpc/metadata"
)

// AuthInterceptor is a client interceptor for authentication
type AuthInterceptor struct {
	authMethods map[string]bool
	accessToken string
}

// NewAuthInterceptor returns a new auth interceptor
func NewAuthInterceptor(
	jwtToken string,
	authMethods map[string]bool,
) (*AuthInterceptor, error) {
	interceptor := &AuthInterceptor{
		authMethods: authMethods,
		accessToken: jwtToken,
	}
	log.Printf("Inside Client AuthIntercept")
	return interceptor, nil
}

// Unary returns a client interceptor to authenticate unary RPC
func (interceptor *AuthInterceptor) Unary() grpc.UnaryClientInterceptor {
	return func(
		ctx context.Context,
		method string,
		req, reply interface{},
		cc *grpc.ClientConn,
		invoker grpc.UnaryInvoker,
		opts ...grpc.CallOption,
	) error {
		log.Printf("--> unary interceptor: %s", method)

		if interceptor.authMethods[method] {
			log.Printf("Method found %s", method)
			return invoker(interceptor.attachToken(ctx), method, req, reply, cc, opts...)
		} else {
			log.Printf("Method Not found %s", method)
		}

		return invoker(ctx, method, req, reply, cc, opts...)
	}
}

func (interceptor *AuthInterceptor) attachToken(ctx context.Context) context.Context {
	return metadata.AppendToOutgoingContext(ctx, "authorization", interceptor.accessToken)
}
