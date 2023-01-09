def build_and_push_image
    # first you need to login to docker with comand: docker login
    system("docker build -t filippogallizia/teo-time-api:latest .")
    system("docker push filippogallizia/teo-time-api:latest")
end