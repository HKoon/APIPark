# 基于官方的基础镜像构建，选择合适的版本（这里假设是一个基于 Linux 的服务，使用 Ubuntu）
FROM ubuntu:20.04

# 更新并安装常见依赖项
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    ca-certificates \
    bash \
    vim \
    && apt-get clean

# 设置工作目录
WORKDIR /app

# 复制当前目录下的所有文件到容器中的 /app 目录
COPY . /app

# 安装必要的依赖
# 假设你需要 Python 环境，你可以根据需求修改安装步骤
RUN apt-get install -y python3 python3-pip

# 安装 APIPark 所需的 Python 包（假设你的项目依赖 Python 包）
RUN pip3 install -r requirements.txt

# 设置环境变量
ENV MYSQL_USER_NAME=root
ENV MYSQL_PWD=123456
ENV MYSQL_IP=apipark-mysql
ENV MYSQL_PORT=3306
ENV MYSQL_DB="apipark"
ENV ERROR_DIR=/work/logs
ENV ERROR_FILE_NAME=error.log
ENV ERROR_LOG_LEVEL=info
ENV ERROR_EXPIRE=7d
ENV ERROR_PERIOD=day
ENV REDIS_ADDR=apipark-redis:6379
ENV REDIS_PWD=123456
ENV ADMIN_PASSWORD=12345678

# 设置暴露端口
EXPOSE 8288

# 设置容器启动时的默认命令
CMD ["./app"]
