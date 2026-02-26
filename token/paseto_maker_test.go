package token

import (
	"testing"
	"time"

	"github.com/anirudha/Transaction-Backend-System/util"
	"github.com/stretchr/testify/require"
)

func TestPasetoMaker(t *testing.T) {
	maker, err := NewPasetoMaker(util.RandomString(32))
	require.NoError(t, err)
	require.NotEmpty(t, maker)

	username := util.RandomOwner()
	duration := time.Minute
	issuedAt := time.Now()
	expiredAt := issuedAt.Add(duration)

	token, err := maker.CreateToken(username, duration)
	require.NoError(t, err)
	require.NotEmpty(t, token)

	payload, err := maker.VerifyToken(token)
	require.NoError(t, err)
	require.NotEmpty(t, payload)

	require.NotNil(t, payload.IssuedAt)
	require.NotNil(t, payload.ExpiresAt)

	require.NotZero(t, payload.ID)
	require.Equal(t, username, payload.Username)
	require.WithinDuration(t, issuedAt, payload.IssuedAt.Time, time.Second)
	require.WithinDuration(t, expiredAt, payload.ExpiresAt.Time, time.Second)
}

func TestExpiredPasetoToken(t *testing.T) {
	maker, err := NewPasetoMaker(util.RandomString(32))
	require.NoError(t, err)
	require.NotEmpty(t, maker)

	token, err := maker.CreateToken(util.RandomOwner(), -time.Minute)
	require.NoError(t, err)
	require.NotEmpty(t, token)

	payload, err := maker.VerifyToken(token)
	require.Error(t, err)
	require.ErrorIs(t, err, ErrExpiredToken)
	require.Nil(t, payload)
}

func TestPasetoInvalidToken(t *testing.T) {
	maker, err := NewPasetoMaker(util.RandomString(32))
	require.NoError(t, err)

	token, err := maker.CreateToken(util.RandomOwner(), time.Minute)
	require.NoError(t, err)

	// Corrupt the token
	invalidToken := token + "abc"

	payload, err := maker.VerifyToken(invalidToken)
	require.Error(t, err)
	require.Nil(t, payload)
}

func TestPasetoWrongKey(t *testing.T) {
	maker1, _ := NewPasetoMaker(util.RandomString(32))
	maker2, _ := NewPasetoMaker(util.RandomString(32))

	token, _ := maker1.CreateToken(util.RandomOwner(), time.Minute)

	payload, err := maker2.VerifyToken(token)

	require.Error(t, err)
	require.Nil(t, payload)
}
