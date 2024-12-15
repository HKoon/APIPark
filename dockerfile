# 阶段 1: 构建前端
FROM node:18 AS frontend-builder
WORKDIR /app/frontend

# 复制前端代码并安装依赖
COPY frontend/package*.json ./
RUN npm install

# 构建前端
COPY frontend ./
RUN npm run build

# 阶段 2: 构建后端
FROM golang:1.20 AS backend-builder
WORKDIR /app

# 复制后端代码
COPY . ./

# 将前端生成的 dist 文件复制到后端目录
COPY --from=frontend-builder /app/frontend/dist ./frontend/dist

# 下载 Go 依赖
RUN go mod download

# 构建后端可执行文件
RUN go build -o out

# 阶段 3: 最终运行环境
FROM alpine:latest
WORKDIR /root/

# 复制可执行文件到最终镜像
COPY --from=backend-builder /app/out .

# 暴露服务运行端口
EXPOSE 8080

# 运行服务
CMD ["./out"]
