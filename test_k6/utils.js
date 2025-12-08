import http from "k6/http";

export function getAuthToken() {
  const apiKey = __ENV.FIREBASE_API_KEY_WEB;
  const email = __ENV.TEST_EMAIL;
  const password = __ENV.TEST_PASSWORD;

  if (!apiKey || !email || !password) {
    throw new Error(
      "Missing required environment variables: FIREBASE_API_KEY_WEB, TEST_EMAIL, or TEST_PASSWORD"
    );
  }

  const url = `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${apiKey}`;

  const payload = JSON.stringify({
    email: email,
    password: password,
    returnSecureToken: true,
  });

  const params = {
    headers: {
      "Content-Type": "application/json",
    },
  };

  const response = http.post(url, payload, params);

  if (response.status === 200) {
    return response.json("idToken");
  } else {
    throw new Error(
      `Failed to get token: Status ${response.status} - ${response.body}`
    );
  }
}
