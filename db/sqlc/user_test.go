package db

import (
	"context"
	"testing"
	"time"

	"github.com/anirudha/Transaction-Backend-System/util"
	"github.com/stretchr/testify/require"
)

func createRandomUser(t *testing.T) User {
	hashedPassword, err := util.HashPassword(util.RandomString(6))
	require.NoError(t, err)

	arg := CreateUserParams{
		Username:       util.RandomOwner(),
		HashedPassword: hashedPassword,
		FullName:       util.RandomOwner(),
		Email:          util.RandomEmailID(),
	}

	user, err := testQueries.CreateUser(context.Background(), arg)

	require.NoError(t, err)
	require.NotEmpty(t, user)
	require.Equal(t, arg.Username, user.Username)
	require.Equal(t, arg.HashedPassword, user.HashedPassword)
	require.Equal(t, arg.FullName, user.FullName)
	require.Equal(t, arg.Email, user.Email)

	require.True(t, user.PasswordChangedAt.IsZero())
	require.NotZero(t, user.CreatedAt)

	return user
}

func TestCreateUser(t *testing.T) {
	createRandomUser(t)
}

func TestGetUser(t *testing.T) {
	randomUser := createRandomUser(t)
	user, err := testQueries.GetUser(context.Background(), randomUser.Username)

	require.NoError(t, err)
	require.NotEmpty(t, user)
	require.Equal(t, user.Username, randomUser.Username)
	require.Equal(t, randomUser.Email, user.Email)
	require.Equal(t, randomUser.HashedPassword, user.HashedPassword)

	require.WithinDuration(t, randomUser.PasswordChangedAt, user.PasswordChangedAt, time.Second)
	require.WithinDuration(t, randomUser.CreatedAt, user.CreatedAt, time.Second)
}

// func TestUpdateAccount(t *testing.T) {
// 	randomAccount := createRandomAccount(t)

// 	arg := UpdateAccountParams{
// 		ID:      randomAccount.ID,
// 		Balance: util.RandomMoney(),
// 	}

// 	account, err := testQueries.UpdateAccount(context.Background(), arg)

// 	require.NoError(t, err)
// 	require.NotEmpty(t, account)

// 	require.Equal(t, randomAccount.ID, account.ID)
// 	require.Equal(t, randomAccount.Owner, account.Owner)
// 	require.Equal(t, arg.Balance, account.Balance)
// 	require.Equal(t, randomAccount.Currency, account.Currency)
// 	require.WithinDuration(t, randomAccount.CreatedAt, account.CreatedAt, time.Second)
// 	require.NotZero(t, account.CreatedAt)
// }

// func TestDeleteAccount(t *testing.T) {
// 	randomAccount := createRandomAccount(t)
// 	err := testQueries.DeleteAccount(context.Background(), randomAccount.ID)
// 	require.NoError(t, err)

// 	account, err := testQueries.GetAccount(context.Background(), randomAccount.ID)
// 	require.Error(t, err)
// 	require.EqualError(t, err, sql.ErrNoRows.Error())
// 	require.Empty(t, account)
// }
