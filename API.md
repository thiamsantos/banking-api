## POST /api/accounts

Create an account. Every account starts with a balance of R$ 1000,00.

### Request parameters

| Parameter | Type   | Description |
|:----------|:-------|:------------|
| email     | string | Valid email address, with a max of 255 characters |
| password  | string | A password with minimum of 12 characters and a max of 255 characters|

### Success response

Code: 201 (created).

| Value | Type | Description |
|:------|:-----|:------------|
| email   | string | The email of created account |
| id      | string | UUID of the account |
| balance | integer | Current balance of the account in cents. Ex: R$ 1000,00 = 100000.

### Error response

**Required params**

Code: 422

Body:

```json
{
  "errors": {
    "email": [
      "can't be blank"
    ],
    "password": [
      "can't be blank"
    ]
  }
}
```

**Invalid email**

Code: 422

```json
{
  "errors": {
    "email": [
      "has invalid format"
    ]
  }
}
```

**Password too short**

Code: 422

```json
{
  "errors": {
    "password": [
      "should be at least 12 character(s)"
    ]
  }
}
```

**Email already taken**

Code: 422

```json
{
  "errors": {
    "email": [
      "has already been taken"
    ]
  }
}
```

### Example

**Request**

```json
{
  "email": "test@gmail.com",
  "password": "secure_password"
}
```

**Response**

```json
{
  "data": {
    "balance": 100000,
    "email": "example@gmail.com",
    "id": "1acdf3b5-d718-4a56-bb99-6ec25cd53e33"
  }
}
```

## POST /api/session-tokens

Create a session token.

### Request headers

### Request parameters

### Success response

### Error response

### Example

**Request**

```json

```

**Response**

```json

```

## POST /api/transfers

Create a transfer.

### Request parameters

### Success response

### Error response

### Example

**Request**

```json

```

**Response**

```json

```

## POST /api/withdrawals

Create a withdrawal.

### Request parameters

### Success response

### Error response

### Example

**Request**

```json

```

**Response**

```json

```

## POST /backoffice/operators

Create a backoffice operator.

### Request parameters

### Success response

### Error response

### Example

**Request**

```json

```

**Response**

```json

```

## POST /backoffice/session-tokens

Create a session token.

### Request parameters

### Success response

### Error response

### Example

**Request**

```json

```

**Response**

```json

```

## GET /backoffice/transactions-report

Get the transactions report.

### Request parameters

### Success response

### Error response

### Example

**Request**

```json

```

**Response**

```json

```
