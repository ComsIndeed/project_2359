import * as React from 'react';
import { TextInput, View } from 'react-native';
import { cn } from '../../lib/utils';

const Input = React.forwardRef<TextInput, React.ComponentPropsWithoutRef<typeof TextInput>>(
    ({ className, ...props }, ref) => {
        return (
            <TextInput
                ref={ref}
                className={cn(
                    'flex h-10 w-full rounded-md border border-gray-200 bg-white px-3 py-2 text-sm text-black',
                    className
                )}
                placeholderTextColor="#6b7280"
                {...props}
            />
        );
    }
);
Input.displayName = 'Input';

export { Input };
