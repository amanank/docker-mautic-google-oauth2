#!/bin/sh

# Define the file to be patched
FILE="/opt/mautic/vendor/symfony/google-mailer/Transport/GmailTransportFactory.php"

# Define the function to be added
FUNCTION=$(cat <<'EOF'

    protected function getPassword(Dsn $dsn): string
    {
        $response = $this->client->request('POST', 'https://oauth2.googleapis.com/token', [
            'body' => [
                'client_id' => $dsn->getOption('client_id'),
                'client_secret' => $dsn->getOption('client_secret'),
                'refresh_token' => $dsn->getOption('refresh_token'),
                'grant_type' => 'refresh_token',
            ],
        ]);

        $data = $response->toArray();
        return $data['access_token'];
    }
EOF
)


# Check if the function already exists in the file
if ! grep -q "protected function getPassword(Dsn \$dsn): string" $FILE; then
    # Remove the last closing brace
    sed -i '$ d' $FILE
    # Append the function and the closing brace
    echo "$FUNCTION" >> $FILE
    echo "}" >> $FILE
else
    echo "Patch already applied."
fi