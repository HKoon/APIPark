# 使用官方的 Golang 镜像作为基础镜像
FROM golang:1.20-alpine AS builder

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY . .

# 下载依赖
RUN go mod download

# 构建可执行文件
RUN go build -o apipark

# 使用更小的基础镜像
FROM alpine:latest

# 设置工作目录
WORKDIR /root/

# 从构建阶段复制可执行文件
COPY --from=builder /app/apipark .

# 暴露服务端口（根据 APIPark 的配置，假设为 8080）
EXPOSE 8080

# 运行可执行文件
CMD ["./apipark"]
