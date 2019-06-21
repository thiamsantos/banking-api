## POST /api/accounts

Create an account. Every account starts with a balance of R$ 1000,00.

### Request headers

| Header | Value   | Description |
|:----------|:-------|:------------|
| Content-Type | application/json | As for now the API only accepts json body |
| Accepts | application/json | As for now the API only responds to json |

### Request parameters

| Parameter | Type   | Description |
|:----------|:-------|:------------|
| email     | string | Valid email address, with a max of 255 characters |
| password  | string | A password with minimum of 12 characters and a max of 255 characters |

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

**Not acceptable**

Code: 406

```json
{
  "errors": {
    "detail": "Not Acceptable"
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

Create a session token for banking requests.

### Request headers

| Header | Value   | Description |
|:----------|:-------|:------------|
| Content-Type | application/json | As for now the API only accepts json body |
| Accepts | application/json | As for now the API only responds to json |

### Request parameters

| Parameter | Type   | Description |
|:----------|:-------|:------------|
| email     | string | The account's email |
| password  | string | The account's password |

### Success response

Code: 201 (created).

| Value | Type | Description |
|:------|:-----|:------------|
| session_token | string | A JWT token with ttl of 15 minutes |

### Error response

**Required params**

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

**Email not found**

Code: 422.

Body:

```json
{
  "errors": {
    "email": [
      "Invalid email or password"
    ]
  }
}
```

**Invalid password**

Code: 422.

Body:

```json
{
  "errors": {
    "email": [
      "Invalid email or password"
    ]
  }
}
```

**Not acceptable**

Code: 406

```json
{
  "errors": {
    "detail": "Not Acceptable"
  }
}
```

### Example

**Request**

```json
{
  "email": "valid@mail.com",
  "password": "secure_password"
}
```

**Response**

```json
{
  "data": {
    "session_token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJiYW5raW5nIiwiZXhwIjoxNTYxMTM2ODI0LCJpYXQiOjE1NjExMzU5MjQsImlzcyI6ImJhbmtpbmciLCJqdGkiOiI4NTYxYWIyOC02NTNmLTQzMWYtYjk2Yy0zNzU5NzZiMDcyNDMiLCJuYmYiOjE1NjExMzU5MjMsInN1YiI6Ijg0NzJjY2ZkLWE3MzEtNGU2Ny04ZGRhLTAyMjZiZTBkYjdlOSIsInR5cCI6ImFjY2VzcyJ9.t3AQ2XaI2dlUNmf-BPniHbPT3Qvs827Q0BuN-curwKOyLpGcrWYUe-y0Bc0C_XmxDQdgu09QMPufamBZz4GcMA"
  }
}
```

## POST /api/transfers

Create a transfer.

### Request headers

| Header | Value   | Description |
|:----------|:-------|:------------|
| Content-Type | application/json | As for now the API only accepts json body |
| Accepts | application/json | As for now the API only responds to json |

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

### Request headers

| Header | Value   | Description |
|:----------|:-------|:------------|
| Content-Type | application/json | As for now the API only accepts json body |
| Accepts | application/json | As for now the API only responds to json |

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

### Request headers

| Header | Value   | Description |
|:----------|:-------|:------------|
| Content-Type | application/json | As for now the API only accepts json body |
| Accepts | application/json | As for now the API only responds to json |

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

### Request headers

| Header | Value   | Description |
|:----------|:-------|:------------|
| Content-Type | application/json | As for now the API only accepts json body |
| Accepts | application/json | As for now the API only responds to json |

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
