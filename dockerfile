# 使用官方的 Node 镜像
FROM node:18 AS frontend-builder
WORKDIR /app/frontend

# 安装依赖并构建
COPY frontend/package*.json ./
RUN npm install
COPY frontend ./
RUN npm run build

# 使用 Golang 镜像进行后端构建
FROM golang:1.20 AS backend-builder
WORKDIR /app

# 复制前端构建的 dist 文件夹
COPY --from=frontend-builder /app/frontend/packages/core/dist ./dist

# 复制后端代码
COPY . ./

# 下载并构建后端服务
RUN go mod download
RUN go build -o out

# 使用更轻量的镜像作为最终镜像
FROM alpine:latest
WORKDIR /root/

# 复制构建后的应用
COPY --from=backend-builder /app/out .

EXPOSE 8080
CMD ["./out"]
