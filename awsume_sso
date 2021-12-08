 #!/bin/bash


unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset AWS_DEFAULT_REGION


profile=$1

profile_lower=$(echo "$profile" | tr '[:upper:]' '[:lower:]')

if [[ "$profile_lower" == *"help"* ]] || [[ -z "$profile_lower" ]]; then
    echo "This is for use with AWS CLI version 2"
    echo "Please ensure you have logged in via: aws sso login --profile <profile_name>"
    echo "Then provide this profile_name here as an argument: source ./awsume_sso <profile_name>"
    return 20
fi

aws sts get-caller-identity --profile ${profile} 1> /dev/null
if [ $? -eq 0 ]; then
    echo "Profile $profile found"
else
    echo "Please run aws sso login --profile ${profile}"
    echo "For more info ./awsume_sso help"
    return 21
fi


aws_role=$(aws configure get sso_role_name --profile ${profile})
aws_account=$(aws configure get sso_account_id --profile ${profile})
aws_region=$(aws configure get region --profile ${profile})

files=$(ls ~/.aws/sso/cache/ | grep ".json")
for json_file in ~/.aws/sso/cache/*.json; do
    # echo $json_file
    if ( cat "${json_file}" | grep "accessToken" 1> /dev/null ); then
        access_token=$(cat "${json_file}" | jq -r ".accessToken") 
    fi
done

if [[ -z "$access_token" ]]; then
    echo "access token generated via aws sso login not found. For more information see:"
    echo "https://aws.amazon.com/premiumsupport/knowledge-center/sso-temporary-credentials/"
    return 22
fi


temp_creds=$(aws sso get-role-credentials --account-id ${aws_account} --role-name ${aws_role} --access-token ${access_token} --region ${aws_region})

access_key=$(echo ${temp_creds} | jq -r ".roleCredentials.accessKeyId")
secret_key=$(echo ${temp_creds} | jq -r ".roleCredentials.secretAccessKey")
session_token=$(echo ${temp_creds} | jq -r ".roleCredentials.sessionToken")

export AWS_ACCESS_KEY_ID=${access_key}
export AWS_SECRET_ACCESS_KEY=${secret_key}
export AWS_SESSION_TOKEN=${session_token}
export AWS_DEFAULT_REGION=${aws_region}

echo ${AWS_ACCESS_KEY_ID}
