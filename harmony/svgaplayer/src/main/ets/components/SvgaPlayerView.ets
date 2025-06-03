/**
 * Copyright (c) 2024 Huawei Technologies Co., Ltd.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE-MIT file in the root directory of this source tree.
 */

import { RNOHContext, RNViewBase } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated/ts";
import { SvgaPlayerV2, SvgaController } from '@tb-open/svga';

@Component
export struct SvgaPlayerView {
  public static readonly NAME:string = RNC.SvgaPlayerView.NAME;
  private controller: SvgaController = new SvgaController({
    loops: Infinity,                    // 播放3次
    fillMode: 'forwards',        // 播放结束后停留在最后一帧
    pageUpdateMode: 'pause',     // 页面切换时暂停动画
    autoRelease: true,           // 页面销毁时自动释放资源
    clearsAfterStop: true        // 停止播放后清理资源
  });
  public ctx!: RNOHContext;
  public tag: number = 0;
  @State descriptorWrapper: RNC.SvgaPlayerView.DescriptorWrapper = {} as RNC.SvgaPlayerView.DescriptorWrapper;
  @State source:string='';
  private eventEmitter: RNC.SvgaPlayerView.EventEmitter | undefined = undefined;
  private cleanUpCallbacks: (() => void)[] = [];

  aboutToAppear() {
    this.eventEmitter = new RNC.SvgaPlayerView.EventEmitter(this.ctx.rnInstance, this.tag);
    this.onDescriptorWrapperChange(this.ctx.descriptorRegistry.findDescriptorWrapperByTag<RNC.SvgaPlayerView.DescriptorWrapper>(this.tag)!);
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (descriptor) => {
        this.onDescriptorWrapperChange(new RNC.SvgaPlayerView.DescriptorWrapper(descriptor));
      }
    ))
    this.cleanUpCallbacks.push(new RNC.SvgaPlayerView.CommandReceiver(this.ctx.componentCommandReceiver,
      this.tag).subscribe("emitNativeEvent", (argv:boolean[]) => {
      console.log(`收到 RN 传来的消息 ================ ${JSON.stringify(argv)}`);
      // this.mutil = argv[0] || false;
    }))
  }

  private onDescriptorWrapperChange(descriptorWrapper: RNC.SvgaPlayerView.DescriptorWrapper) {
    this.descriptorWrapper = descriptorWrapper;
    // this.data = [];
    // const data = this.descriptorWrapper.props.data;
    // const value = this.descriptorWrapper.props.value;
    // for (const item of data) {
    //   this.data.push(
    //     new SelectItems(item.id, item.text, value.includes(item.id))
    //   )
    // }
    this.source = this.descriptorWrapper.props?.source;
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb());
  }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      // 声明式UI 2.0版本组件
      SvgaPlayerV2({
        url:  this.source,
        controller: this.controller
      })
      // Button("确定")
      //   .onClick(() => {
      //     const value = this.data
      //       .filter((item: SelectItems) => item.selected)
      //       .map((item: SelectItems) => item.id)
      //     // 发送事件方式[1]
      //     // this.ctx.rnInstance.emitComponentEvent(this.tag, "change", { value })
      //     // 发送事件方式[2]
      //     this.eventEmitter!.emit("change", {
      //       value,
      //     })
      //   })
    }
  }
}