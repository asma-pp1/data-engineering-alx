# HTTP status codes

Every web request gets back a number saying how it went.
Opening any web page in your browser is a GET (REST)
Standard across the whole internet, not specific to any API.

## Quick reference
| Code | Meaning |
|------|---------|
| 200  | OK |
| 401  | Bad or missing API key |
| 404  | Not found (bad URL or city) |
| 429  | Too many requests — rate limit |
| 500  | Server broke (their fault, retry later) |

First digit is the rule:
2xx = it worked, 3xx = moved elsewhere,
4xx = request was wrong (my fault), 5xx = server broke (their fault).

## Gotcha
Some APIs return 200 with an error message inside the body.
200 means "answered", not "you got what you wanted".