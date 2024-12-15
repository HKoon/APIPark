# 使用多阶段构建以优化镜像大小

# 阶段 1: 构建前端
FROM node:18 AS frontend-builder
WORKDIR /app/frontend

# 复制前端代码
COPY frontend/package*.json ./
RUN npm install

COPY frontend ./
RUN npm run build

# 阶段 2: 构建后端
FROM golang:1.20 AS backend-builder
WORKDIR /app

# 复制后端代码
COPY . ./

# 复制前端构建产物到后端目录
COPY --from=frontend-builder /app/frontend/dist ./frontend/dist

# 下载依赖
RUN go mod download

# 构建后端服务
RUN go build -o out

# 阶段 3: 最终镜像
FROM alpine:latest
WORKDIR /root/

# 复制可执行文件
COPY --from=backend-builder /app/out .

# 暴露端口（假设服务运行在 8080 端口）
EXPOSE 8080

# 启动服务
CMD ["./out"]
