package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
)

//TODO: gRPC Call for Google OAuth2 Authentication https://medium.com/google-cloud/grpc-authentication-with-google-openid-connect-tokens-812ceb3e5c41

//OAuthInfo contains data returned from OAuth2 Verifier
type OAuthInfo struct {
	ID            string `json:"id"`
	Email         string `json:"email"`
	VerifiedEmail bool   `json:"verified_email"`
	Picture       string `json:"picture"`
}

var (
	googleOauthConfig *oauth2.Config
	// TODO: randomize it
	oauthStateString = "pseudo-random"
)

func init() {
	googleOauthConfig = &oauth2.Config{
		RedirectURL:  "http://localhost:4040/callback",
		ClientID:     "392376614027-qpuh3t81joaucdt4kcgpq84gbfqrr83f.apps.googleusercontent.com",
		ClientSecret: "0ISYm6CUhkyezn_JpBzV1lIA",
		Scopes:       []string{"https://www.googleapis.com/auth/userinfo.email"},
		Endpoint:     google.Endpoint,
	}
}

func main() {
	// 392376614027-qpuh3t81joaucdt4kcgpq84gbfqrr83f.apps.googleusercontent.com
	// 0ISYm6CUhkyezn_JpBzV1lIA
	http.HandleFunc("/", handleMain)
	http.HandleFunc("/login", handleGoogleLogin)
	http.HandleFunc("/callback", handleGoogleCallback)
	fmt.Println(http.ListenAndServe(":8080", nil))
}

func handleMain(w http.ResponseWriter, r *http.Request) {
	var htmlIndex = `<html>
<body>
	<a href="/login">Google Log In</a>
</body>
</html>`

	fmt.Fprintf(w, htmlIndex)
}

func handleGoogleLogin(w http.ResponseWriter, r *http.Request) {
	url := googleOauthConfig.AuthCodeURL(oauthStateString)
	http.Redirect(w, r, url, http.StatusTemporaryRedirect)
}

func handleGoogleCallback(w http.ResponseWriter, r *http.Request) {
	userInfo, err := getUserInfo(r.FormValue("state"), r.FormValue("code"))
	if err != nil {
		fmt.Println(err.Error())
		http.Redirect(w, r, "/", http.StatusTemporaryRedirect)
		return
	}

	fmt.Println(userInfo.Email)

	/*jwt := auth.NewJWTManager("foo", time.Minute*5)
	token, err := jwt.Generate(&auth.User{
		Username: userInfo.Email,
		Id:       userInfo.ID,
	})
	if err != nil {
		fmt.Println("Unable to generate token")
	}
	fmt.Println(token)*/
}

func getUserInfo(state string, code string) (*OAuthInfo, error) {
	if state != oauthStateString {
		return nil, fmt.Errorf("invalid oauth state")
	}

	fmt.Println(code)

	token, err := googleOauthConfig.Exchange(oauth2.NoContext, code)

	if err != nil {
		return nil, fmt.Errorf("code exchange failed: %s", err.Error())
	}

	response, err := http.Get("https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + token.AccessToken)
	if err != nil {
		return nil, fmt.Errorf("failed getting user info: %s", err.Error())
	}
	defer response.Body.Close()
	contents, err := ioutil.ReadAll(response.Body)
	if err != nil {
		return nil, fmt.Errorf("failed reading response body: %s", err.Error())
	}

	/*pingJSON := make(map[string][]pingDataFormat)
	err := json.Unmarshal([]byte(pingData), &pingJSON)
	if err != nil { panic(err) }
	fmt.Printf("\n\n json object:::: %v", pingJSON)
	*/

	var userInfo OAuthInfo
	err = json.Unmarshal(contents, &userInfo)
	if err != nil {
		panic(err)
	}
	return &userInfo, nil
}
