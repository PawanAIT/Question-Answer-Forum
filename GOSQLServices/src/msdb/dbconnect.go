package msdb

import (
	"context"
	"database/sql"
	"fmt"
	"log"

	_ "github.com/denisenkom/go-mssqldb"
)

var server = "shejari-dev.database.windows.net"
var port = 1433
var user = "sumit"
var password = "shejari@123"
var database = "shejaridatamart"
var err error
var createID int64

//ConnectDatabase connects to database
func ConnectDatabase() *sql.DB {
	connString := fmt.Sprintf("server=%s;user id=%s;password=%s;port=%d;database=%s;",
		server, user, password, port, database)

	var tdb *sql.DB
	// Create connection pool
	tdb, err = sql.Open("sqlserver", connString)
	if err != nil {
		log.Fatal("Error creating connection pool: ", err.Error())
	}
	ctx := context.Background()
	err = tdb.PingContext(ctx)
	if err != nil {
		log.Fatal(err.Error())
	}
	fmt.Printf("Connected!\n")
	return tdb
}

//ReadUsers retuens string of users
func ReadUsers(db *sql.DB) (string, int64, error) {
	ctx := context.Background()

	tsql := fmt.Sprintf("SELECT user_id, first_name, last_name, email FROM Users;")

	// Execute query
	rows, err := db.QueryContext(ctx, tsql)
	if err != nil {
		return "", -1, err
	}
	defer rows.Close()

	var count int64
	var resp string
	// Iterate through the result set.
	for rows.Next() {
		var id int64
		var firstName, lastName, email string

		// Get values from row.
		err := rows.Scan(&id, &firstName, &lastName, &email)
		if err != nil {
			return "", -1, err
		}

		resp += fmt.Sprintf("ID: %d, Name: %s %s, Email: %s||", id, firstName, lastName, email)
		count++
	}

	return resp, count, nil
}

// AddUser adds a user
func AddUser(db *sql.DB, firstName string, lastName string, email string, bio string, profilePicture string) (bool, error) {
	ctx := context.Background()
	var err error

	_, err = db.ExecContext(ctx, "sp_Insert_User_Details",
		sql.Named("first_name", firstName),
		sql.Named("last_name", lastName),
		sql.Named("email", email),
		sql.Named("bio", bio),
		sql.Named("profile_picture", profilePicture),
	)
	if err != nil {
		return false, err
	}

	return true, nil
}

// AddDownvotes adds downvotes
func AddDownvotes(db *sql.DB, id int64, downvotes int64) (bool, error) {
	ctx := context.Background()
	var err error

	_, err = db.ExecContext(ctx, "sp_Add_Downvotes_To_Answer",
		sql.Named("answer_id", id),
		sql.Named("downvotes_to_add", downvotes),
	)
	if err != nil {
		return false, err
	}

	return true, nil
}

/*		path + "FollowTopic":      true,
		path + "FollowUser":       true,
		path + "UnFollowQuestion": true,
		path + "UnFollowTopic":    true,
		path + "UnFollowUser":     true,*/

// AddKudos adds a Kudos
func AddKudos(db *sql.DB, id int64, kudos int64) (bool, error) {
	ctx := context.Background()
	var err error

	_, err = db.ExecContext(ctx, "sp_Add_Kudos_To_Answer",
		sql.Named("answer_id", id),
		sql.Named("kudos_to_add", kudos),
	)
	if err != nil {
		return false, err
	}

	return true, nil
}

// AddAnswer adds an answer
func AddAnswer(db *sql.DB, answerText string, questionID int64, userID int64) (bool, error) {
	ctx := context.Background()
	var err error

	_, err = db.ExecContext(ctx, "sp_Insert_Answer",
		sql.Named("answer_text", answerText),
		sql.Named("answer_poster_id", questionID),
		sql.Named("question_id", userID),
	)
	if err != nil {
		return false, err
	}

	return true, nil
}

// AddQuestion adds a question
func AddQuestion(db *sql.DB, questionTitle string, questionDetails string, posterID int64, topicID int64) (bool, error) {
	ctx := context.Background()
	var err error

	_, err = db.ExecContext(ctx, "sp_Insert_Question",
		sql.Named("question_title", questionTitle),
		sql.Named("question_details", questionDetails),
		sql.Named("question_poster_id", posterID),
		sql.Named("question_topic_id", topicID),
	)
	if err != nil {
		return false, err
	}

	return true, nil
}

// AddTopic adds a topic
func AddTopic(db *sql.DB, topic string) (bool, error) {
	ctx := context.Background()
	var err error

	_, err = db.ExecContext(ctx, "sp_Insert_Topic",
		sql.Named("topic_name", topic),
	)
	if err != nil {
		return false, err
	}

	return true, nil
}

// FollowQuestion Adds a follow connection
func FollowQuestion(db *sql.DB, followerID int64, questionID int64) (bool, error) {
	ctx := context.Background()
	var err error

	_, err = db.ExecContext(ctx, "sp_Follow_Question",
		sql.Named("follower_user_id", followerID),
		sql.Named("followed_question_id", questionID),
	)
	if err != nil {
		return false, err
	}

	return true, nil
}

// FollowUser Adds a follow connection
func FollowUser(db *sql.DB, followerID int64, userID int64) (bool, error) {
	ctx := context.Background()
	var err error

	_, err = db.ExecContext(ctx, "sp_Follow_User",
		sql.Named("follower_user_id", followerID),
		sql.Named("followed_user_id", userID),
	)
	if err != nil {
		return false, err
	}

	return true, nil
}

// FollowTopic Adds a follow connection
func FollowTopic(db *sql.DB, followerID int64, topicID int64) (bool, error) {
	ctx := context.Background()
	var err error

	_, err = db.ExecContext(ctx, "sp_Follow_Topic",
		sql.Named("follower_user_id", followerID),
		sql.Named("followed_topic_id", topicID),
	)
	if err != nil {
		return false, err
	}

	return true, nil
}

// UnfollowQuestion Adds an unfollow connection
func UnfollowQuestion(db *sql.DB, followerID int64, questionID int64) (bool, error) {
	ctx := context.Background()
	var err error

	_, err = db.ExecContext(ctx, "sp_Unfollow_Question",
		sql.Named("unfollower_user_id", followerID),
		sql.Named("unfollowed_question_id", questionID),
	)
	if err != nil {
		return false, err
	}

	return true, nil
}

// UnfollowTopic Adds an unfollow connection
func UnfollowTopic(db *sql.DB, followerID int64, topicID int64) (bool, error) {
	ctx := context.Background()
	var err error

	_, err = db.ExecContext(ctx, "sp_Unfollow_Topic",
		sql.Named("unfollower_user_id", followerID),
		sql.Named("unfollowed_topic_id", topicID),
	)
	if err != nil {
		return false, err
	}

	return true, nil
}

// UnfollowUser Adds an unfollow connection
func UnfollowUser(db *sql.DB, followerID int64, userID int64) (bool, error) {
	ctx := context.Background()
	var err error

	_, err = db.ExecContext(ctx, "sp_Unfollow_User",
		sql.Named("unfollower_user_id", followerID),
		sql.Named("unfollowed_user_id", userID),
	)
	if err != nil {
		return false, err
	}

	return true, nil
}
