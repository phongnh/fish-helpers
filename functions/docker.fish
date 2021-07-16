function docker-login-v1
    eval (aws ecr get-login --no-include-email $argv)
end

function docker-login
    set -l ECR_REGISTRY_URL
    if test -n "$AWS_DEFAULT_REGION"
        set ECR_REGISTRY_URL "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com"
    else
        set ECR_REGISTRY_URL "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
    end
    aws ecr get-login-password $argv | docker login --username AWS --password-stdin "$ECR_REGISTRY_URL"
end
