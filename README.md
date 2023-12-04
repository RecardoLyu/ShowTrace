# README

## Profile

分为2个Section，第一部分展示activate之前的数据，第二个Section展示activate之后的数据；

<img src=".\resource\target.png" style="zoom:50%;" />

## Section 1

Title：Before activation；

效果：简单展示activate之前的细胞

## Section 3

Title：ROI of  405nm activation；

效果：标记激活区域并Zoom in到ROI

## Section 2

Title：after 405nm activation；

效果：跟踪左上方细胞中的荧光部分并画出移动轨迹热度图（based on timescale）


---

## 2023年11月16日新增要求：

- ~~修改每段text：activate首字母小写，加上activate wavelength=405nm；~~

- ~~增加一段：用线标识激活区域，持续1~2s；~~

- ~~后续增加ROI_Zoomin和ROI_Activate；~~

- ~~实现Zoom in，这里还需要加一段Section 4——考虑先画线再最后直接Zoom in~~

- ~~加粗~~~~加密~~绘制的曲线，~~调整ColorMap~~；

- ~~增大对比度（加一个高斯窗调制？）；~~

- ~~初始帧亮度降低；~~

## 2023年11月17日增加要求：

- ~~更改画面比例为16：9，画面填充在中间，其余背景部分黑色填充~~

## 2023年11月24日增加要求：

- ~~colorbar 右移一些~~
- ~~算出来细胞边界加上去，紫色？~~
- ~~activation ROI加上其他两块~~
- 加上scale bar，~~再增加一些点~~
- ~~背景稍微亮一点~~

## 2023年12月4日

改进轨迹绘制：自动插值
修改轨迹数据格式：$$m \times n \times 4$$，m 是轨迹的数量，n是每条轨迹目前的点数，4分别是轨迹序号，时间，行跟列，

