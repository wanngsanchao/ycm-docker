1、准备物料，提前准备好.vinrc和vim9.1的文件
```
https://github.com/vim/vim/archive/refs/tags/v9.1.xxxx.tar.gz
.vimrc文件采用日常使用的文件
```
2、Dockerfile内容如下
```
FROM rockylinux:9

# 安装 epel-release
RUN dnf install -y epel-release \
    && dnf clean all

# 配置阿里云 Rocky Linux 8 CRB 镜像源
RUN echo "[crb]" > /etc/yum.repos.d/rocky-crb.repo \
    && echo "name=Rocky Linux \$releasever - CRB" >> /etc/yum.repos.d/rocky-crb.repo \
    && echo "baseurl=https://mirrors.aliyun.com/rockylinux/\$releasever/CRB/\$basearch/os/" >> /etc/yum.repos.d/rocky-crb.repo \
    && echo "gpgcheck=1" >> /etc/yum.repos.d/rocky-crb.repo \
    && echo "gpgkey=https://mirrors.aliyun.com/rockylinux/RPM-GPG-KEY-rockyofficial" >> /etc/yum.repos.d/rocky-crb.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/rocky-crb.repo \
    && echo "metadata_expire=6h" >> /etc/yum.repos.d/rocky-crb.repo \
    && echo "countme=1" >> /etc/yum.repos.d/rocky-crb.repo

# 启用 crb 仓库（通过配置文件已启用，可省略单独启用命令，若需校验可保留）
RUN dnf config-manager --set-enabled crb \
    && dnf clean all

# 清理缓存、生成新缓存并安装 dnf-plugins-core
RUN dnf clean all \
    && dnf makecache \
    && dnf install -y dnf-plugins-core \
    && dnf clean all

# 后续继续执行系统更新、安装其他依赖等步骤...
RUN dnf -y update \
    && dnf -y install \
        vim \
        git \
        gcc \
        gcc-c++ \
        make \
        cmake \
        python3 \
        python3-devel \
        python3-pip \
        clang \
        clang-devel \
        golang \
        pkgconfig \
        openssl-devel \
    && dnf clean all

# 配置 Python 环境
RUN pip3 install --upgrade pip \
    && pip3 install jedi

# 配置 Golang 环境
ENV GOPATH=/root/go
ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
ENV GOPROXY=https://goproxy.cn,direct \
    GOSUMDB=sum.golang.google.cn

RUN go install golang.org/x/tools/gopls@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest

# 配置 VIM 和 Vundle
RUN mkdir -p /root/.vim/bundle \
    && git clone https://github.com/VundleVim/Vundle.vim.git /root/.vim/bundle/Vundle.vim

# 下载 YCM
RUN git clone https://github.com/ycm-core/YouCompleteMe.git /root/.vim/bundle/YouCompleteMe \
    && cd /root/.vim/bundle/YouCompleteMe \
    && git submodule update --init --recursive

# 编译 YCM（支持 C、Go、Python）
RUN cd /root/.vim/bundle/YouCompleteMe \
    && python3 install.py --clangd-completer --go-completer --force-sudo

# 创建VIM配置文件（替换为用户提供的内容）
COPY .vimrc /root/.vimrc

#卸载先前安装的vim

RUN dnf remove -y vim-minimal vim-common vim-enhanced

#把本地的vim压缩包拷贝到容器内部，进行编译
COPY vim-9.1.0600.tar.gz ./

#安装编译工具
RUN dnf install -y gcc ncurses-devel make git \
 && tar xf vim-9.1.0600.tar.gz && cd vim-9.1.0600 \
 && ./configure --with-features=huge --enable-python3interp \
 && make -j$(nproc) && make install \
 && ln -sf /usr/local/bin/vim /usr/bin/vim \
 && cd .. && rm -rf vim-*


# 初始化插件
#RUN vim +PluginInstall +qall > /dev/null 2>&1
RUN vim +PluginInstall +qall

# 设置工作目录
WORKDIR /workspace

# 启动终端
CMD ["tail", "-f", "/dev/null"]
```
