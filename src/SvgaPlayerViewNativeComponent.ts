import {HostComponent, ViewProps} from 'react-native';
import codegenNativeCommands from 'react-native/Libraries/Utilities/codegenNativeCommands';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

interface SvgaPlayerProps extends ViewProps {
  url: string;
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
