# serverless-app-runner
Example for deploying python gradio server to AWS App Runner with Serverless

# Required Software
- Node 18.18.1
- Conda

# Setup Node and Conda

Ensure you have the serverless cli installed.

  - npm install
  - conda create -n serverless-app-runner python=3.11
  - conda activate serverless-app-runner
  - pip install -r requirements.txt

# Running Locally

  - Fill out the example `.env` file and save as `.env` for local development
  - From the conda environment run `python main.py`

# Deployment

To deploy, run:

  `sls deploy -s <stage> --aws-profile <profile>`

This will automatically create an ecr repository, build the docker image and push it, and then deploy app runner and an S3 bucket.

To remove the stack. Delete logs from the S3 bucket defined here and run the following to remove the bucket and app runner itself:

  `sls remove -s <stage> --aws-profile <profile>`

# Tear Down Conda

  conda remove -n serverless-app-runner --all

## Disclaimers

Some of the components I generated because they were somewhat irrelevant to my use case to demonstrate how access role and instance role would work when deploying to App Runner, an example is the S3 policy.

I didn't intentionally use serverless V4, and use V3 at time of writing and used V3 in the actual production design that uses a similar pattern.