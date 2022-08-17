accountID=$(aws sts get-caller-identity --query "Account" --output text)
roleName="lambda_rds"
subnetID="subnet-0000000000"
securityGroupID="sg-000000000"

# Make sure project starts blank
aws lambda delete-function --function-name challenge_lambda_func
rm -r ./lambda_function
rm -r ./pymysql
rm -r ./PyMySQL-1.0.2.dist-info

# Create necessary packages
mkdir ./lambda_function
python3 -m venv ./lambda_function/lambdaVENV
source ./lambda_function/lambdaVENV/bin/activate
pip3 install pymysql
deactivate
rm -rf ./lambda_function/test.zip
cp -r ./lambda_function/lambdaVENV/lib/python3.8/site-packages/pymysql ./
cp -r ./lambda_function/lambdaVENV/lib/python3.8/site-packages/PyMySQL-1.0.2.dist-info ./

# Zip files together
zip -r ./lambda_function/test.zip ./pymysql
zip -r ./lambda_function/test.zip ./PyMySQL-1.0.2.dist-info
zip -j ./lambda_function/test.zip ./challenge_lambda.py

# Deploy lambda function
aws lambda create-function \
--function-name challenge_lambda_func \
--zip-file fileb://lambda_function/test.zip \
--handler challenge_lambda.lambda_handler \
--runtime python3.8 \
--role arn:aws:iam::${accountID}:role/${roleName} \
--vpc-config SubnetIds=${subnetID},SecurityGroupIds=${securityGroupID}

# Remove leftovers
rm -r ./lambda_function
rm -r ./pymysql
rm -r ./PyMySQL-1.0.2.dist-info