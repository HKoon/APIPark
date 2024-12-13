# 使用 Ubuntu 作为基础镜像
FROM ubuntu:20.04

# 设置工作目录
WORKDIR /app

# 环境变量设置
ENV DEBIAN_FRONTEND=noninteractive

# 安装基本工具和依赖项
RUN apt-get update && apt-get install -y \
    curl wget jq docker.io dnsutils pwgen \
    bash unzip gnupg lsb-release net-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 复制 quick-start.sh 到容器中
COPY quick-start.sh /app/quick-start.sh

# 确保脚本有执行权限
RUN chmod +x /app/quick-start.sh

# 启动脚本前的准备工作（如禁用 SELinux）
RUN bash -c "sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config || true" && \
    setenforce 0 || true

# 运行 quick-start.sh 以初始化容器中的服务
CMD ["bash", "/app/quick-start.sh"]
