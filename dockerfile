# 使用一个合适的基础镜像
FROM ubuntu:20.04

# 设置时区（根据需要修改）
ENV TZ=Asia/Shanghai

# 更新并安装必要的依赖
RUN apt-get update && \
    apt-get install -y \
    curl \
    bash \
    && rm -rf /var/lib/apt/lists/*

# 下载并执行 quick-start.sh 脚本
RUN curl -sSO https://download.apipark.com/install/quick-start.sh && \
    bash quick-start.sh

# 设置容器启动时执行的命令
CMD ["bash"]
