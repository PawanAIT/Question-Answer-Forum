package auth

// User contains user's information
type User struct {
	Username string
	Role     string
}

// NewUser returns a new user
func NewUser(username string, password string, role string) (*User, error) {

	user := &User{
		Username: username,
		Role:     role,
	}

	return user, nil
}

// Clone returns a clone of this user
func (user *User) Clone() *User {
	return &User{
		Username: user.Username,
		Role:     user.Role,
	}
}
