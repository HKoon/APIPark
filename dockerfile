# 阶段 1: 构建前端
FROM node:18 AS frontend-builder
WORKDIR /app/frontend

# 安装前端依赖
COPY frontend/package*.json ./
RUN npm install

# 构建前端
COPY frontend ./
RUN npm run build

# 阶段 2: 构建后端
FROM golang:1.20 AS backend-builder
WORKDIR /app

# 复制前端生成的 dist 文件夹
COPY --from=frontend-builder /app/frontend/dist ./dist

# 复制后端代码
COPY . ./

# 下载后端依赖
RUN go mod download

# 构建后端服务
RUN ls -alh /app/dist # 调试: 确认 dist 是否存在
RUN go build -o out

# 阶段 3: 最终运行环境
FROM alpine:latest
WORKDIR /root/

# 复制后端可执行文件
COPY --from=backend-builder /app/out .

# 暴露端口
EXPOSE 8080

# 启动服务
CMD ["./out"]
