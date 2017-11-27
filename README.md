## Ubuntu 16.04 Docker with GPU Acceleration & OpenGL support

Use the [Dockerfile](./Dockerfile) and the [./build.sh](./build.sh) script to create a Docker image for Ubuntu 16.04 (Xenial) with a shared X11 and support for NVIDIA hardware acceleration and OpenGL. 

Based on
* [facontidavide/ros-docker-gazebo](https://github.com/facontidavide/ros-docker-gazebo)
* [jbohren/rosdocked](https://github.com/jbohren/rosdocked)

### Requirements

This docker image has been build and tested on a machine running Ubuntu 16.04 with `docker` version `17.09.0-ce`.

### Purpose

As mentioned in [this reporsitoy](https://github.com/gandrein/docker_ros_kinetic_cuda9), [`nvidia-docker2`](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0))does not provide OpenGL support. One alternative is to use `nvidia-docker1`. 

On the other hand if OpenGL is required, the same can be achieved by mapping the host machine's NVIDIA drivers to the container. Although this is not a portable and optimal solution since it is dependent on the host machine's NVIDIA drivers, it is useful when either `nvidia-docker1` cannot be used or when one wants to use `nvidia-docker2` but still have OpenGL support.

This solution is based on the Dockerfile from [facontidavide/ros-docker-gazebo](https://github.com/facontidavide/ros-docker-gazebo) repository and this [ROS tutorial](http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration).

### Method

In short, the Dockerfile and the `run.sh` script will perform a mount of the host's NVIDIA driver into the container at `/usr/local/nvidia/lib*`, similar to what the `nvidia-docker1` wrapper is doing according to the [ROS tutorial](http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration).

### Building the image

Run [./build.sh](./build.sh) to build a docker image with the name provided as the first argument.

```
./build.sh GIVEN_IMAGE_NAME
```

### Running a container

Run [./run.sh](./run.sh) with the name chosen in the previous step. This will run and remove the docker image upon exit (i.e., it is ran with the `--rm` flag).

```
./run.sh GIVEN_IMAGE_NAME
```

The `run` script checks for the version of NVIDIA driver on the host and mounts the video driver's lib's folder inside the container at
```
  -v ${NVIDIA_DRIVER}:/usr/local/nvidia/lib \
  -v ${NVIDIA_DRIVER}:/usr/local/nvidia/lib64 \
```

The image also shares the X11 unix socket with the host and it's network interface.

### Testing functionality

#### Test OpenGL

In a terminal window in a container started with [./run.sh](./run.sh), run `glxgears`. 

The `glxgears` GUI should pop-up in a new window. 

If you encounter the following error(s)
```
libGL error: No matching fbConfigs or visuals found
libGL error: failed to load driver: swrast
X Error of failed request:  BadValue (integer parameter out of range for operation)
  Major opcode of failed request:  154 (GLX)
  Minor opcode of failed request:  3 (X_GLXCreateContext)
  Value in failed request:  0x0
  Serial number of failed request:  35
  Current serial number in output stream:  37
```
the NVIDIA drivers were not mounted correctly.

#### Test Hardware Acceleration

To test the NVIDIA HW acceleration inside the container started with [./run.sh](./run.sh), call `nvidia-smi`. The output should be similar to
```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 387.12                 Driver Version: 387.12                    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  Quadro M2000M       Off  | 00000000:01:00.0  On |                  N/A |
| N/A   43C    P5    N/A /  N/A |    792MiB /  4042MiB |     34%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
+-----------------------------------------------------------------------------+
```