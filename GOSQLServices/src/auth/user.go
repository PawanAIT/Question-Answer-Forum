package auth

// User contains user's information
type User struct {
	Username string
	Id       string
}

// NewUser returns a new user
func NewUser(username string, password string, id string) (*User, error) {

	user := &User{
		Username: username,
		Id:       id,
	}

	return user, nil
}

// Clone returns a clone of this user
func (user *User) Clone() *User {
	return &User{
		Username: user.Username,
		Id:       user.Id,
	}
}
