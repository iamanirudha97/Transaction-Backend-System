package db

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
)

func createRandomEntry(t *testing.T, account Account) Entry {
	arg := CreateEntryParams{
		AccountID: account.ID,
		Amount:    account.Balance,
	}
	entry, err := testQueries.CreateEntry(context.Background(), arg)

	require.NoError(t, err)
	require.NotEmpty(t, entry)
	require.Equal(t, arg.Amount, entry.Amount)
	require.Equal(t, arg.AccountID, entry.AccountID)
	require.NotZero(t, entry.ID)
	require.NotZero(t, entry.CreatedAt)

	return entry
}

func TestCreateEntry(t *testing.T) {
	account := createRandomAccount(t)
	createRandomEntry(t, account)
}

func TestGetEntry(t *testing.T) {
	account := createRandomAccount(t)
	randomEntry := createRandomEntry(t, account)

	entry, err := testQueries.GetEntry(context.Background(), randomEntry.ID)

	require.NoError(t, err)
	require.NotEmpty(t, entry)
	require.Equal(t, randomEntry.Amount, entry.Amount)
	require.Equal(t, randomEntry.ID, entry.ID)
	require.Equal(t, randomEntry.AccountID, entry.AccountID)
	require.WithinDuration(t, randomEntry.CreatedAt, entry.CreatedAt, time.Second)
}

func TestListEntries(t *testing.T) {
	account := createRandomAccount(t)

	for range 10 {
		createRandomEntry(t, account)
	}

	args := ListEntriesParams{
		AccountID: account.ID,
		Limit:     5,
		Offset:    5,
	}

	entries, err := testQueries.ListEntries(context.Background(), args)

	require.NoError(t, err)
	require.Len(t, entries, 5)

	for _, entry := range entries {
		require.Equal(t, account.ID, entry.AccountID)
		require.NotEmpty(t, entry)
	}
}
