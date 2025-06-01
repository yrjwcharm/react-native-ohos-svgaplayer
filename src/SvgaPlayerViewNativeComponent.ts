import {HostComponent, ViewProps} from 'react-native';
import {
  DirectEventHandler,
  Float,
} from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeCommands from 'react-native/Libraries/Utilities/codegenNativeCommands';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
interface ICallbacks {
  value: Float;
}
interface SvgaPlayerProps extends ViewProps {
  source: string;
  onFinished?: DirectEventHandler<{}>;
  onFrame?: DirectEventHandler<ICallbacks>;
  onPercentage?: DirectEventHandler<ICallbacks>;
}
type NativeType = HostComponent<SvgaPlayerProps>;
interface NativeCommands {
  emitNativeEvent: (
    viewRef: React.ElementRef<NativeType>,
    mutil: boolean,
  ) => void;
}

export const Commands: NativeCommands = codegenNativeCommands<NativeCommands>({
  supportedCommands: ['emitNativeEvent'],
});

export default codegenNativeComponent<SvgaPlayerProps>(
  'SvgaPlayerView',
) as HostComponent<SvgaPlayerProps>;
