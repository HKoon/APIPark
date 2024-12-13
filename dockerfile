# 基础镜像
FROM golang:1.20 AS builder

# 设置工作目录
WORKDIR /app

# 安装 Node.js 和 npm（前端工具）
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# 复制代码到容器
COPY . .

# 构建前端代码（如果适用）
WORKDIR /app/frontend
RUN yarn install && yarn build  # 确保这里生成 dist 文件

# 返回工作目录并构建 Go 项目
WORKDIR /app
RUN go mod download
RUN go build -o out

# 运行阶段
FROM debian:bookworm-slim
WORKDIR /app
COPY --from=builder /app/out /app/out
CMD ["./out"]
