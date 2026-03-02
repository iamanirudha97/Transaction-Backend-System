package api

import (
	"bytes"
	"encoding/json"
	"io"

	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/go-playground/validator/v10"
)

// ShouldBindJSONStrict binds JSON from the request body into obj and validates it.
// Unlike ShouldBindJSON, it returns an error (400) if the JSON contains any key
// that does not have a corresponding field in obj (unknown fields are disallowed).
func ShouldBindJSONStrict(ctx *gin.Context, obj interface{}) error {
	body, err := io.ReadAll(ctx.Request.Body)
	if err != nil {
		return err
	}

	dec := json.NewDecoder(bytes.NewReader(body))
	dec.DisallowUnknownFields()

	if err := dec.Decode(obj); err != nil {
		return err
	}

	if v, ok := binding.Validator.Engine().(*validator.Validate); ok {
		if err := v.Struct(obj); err != nil {
			return err
		}
	}

	return nil
}
