FROM ros:humble-ros-base-jammy

# 環境変数を設定
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# universeリポジトリを有効化
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    apt-get update

# パッケージリストを更新し、基本的なツールをインストール
RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    vim \
    git \
    python3-pip \
    openssh-client \
    # GUIツール
    x11-apps \
    libgl1-mesa-glx \
    libsm6 \
    libxext6 \
    libxrender1 \
    # colconのインストール
    python3-colcon-common-extensions \
    # ROSの依存関係を解決・インストールするツール
    python3-rosdep \
    # 複数リポジトリの一括管理
    python3-vcstool \
    # ROS用 OpenCVブリッジ
    ros-humble-cv-bridge

# Python OpenCV ライブラリのインストール
RUN pip install --no-cache-dir opencv-python



# ユーザーを作成
ARG UID GID USER_NAME GROUP_NAME PASSWORD HOMEWORKSPACE
RUN groupadd -g $GID $GROUP_NAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USER_NAME && \
    echo $USER_NAME:$PASSWORD | chpasswd && \
    echo "$USER_NAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
USER $USER_NAME

# ワークスペース作成
WORKDIR /home/$USER_NAME/$HOMEWORKSPACE

# ROSのセットアップスクリプトを.bashrcに追記
RUN echo "source /opt/ros/humble/setup.bash" >> /home/$USER_NAME/.bashrc
RUN echo "source ~/$HOMEWORKSPACE/install/setup.bash" >> /home/$USER_NAME/.bashrc

CMD ["bash"]
