import * as React from 'react';
import { Pressable, Text, View, type ViewStyle, type TextStyle } from 'react-native';
import { cva, type VariantProps } from 'class-variance-authority';
import { cn } from '../../lib/utils';

const buttonVariants = cva(
    'group flex flex-row items-center justify-center rounded-md px-4 py-2',
    {
        variants: {
            variant: {
                default: 'bg-black active:opacity-90',
                destructive: 'bg-red-500 active:opacity-90',
                outline: 'border border-black bg-transparent active:bg-gray-100',
                secondary: 'bg-gray-100 active:opacity-80',
                ghost: 'bg-transparent active:bg-gray-100',
                link: 'bg-transparent underline',
            },
            size: {
                default: 'h-10 px-4 py-2',
                sm: 'h-9 rounded-md px-3',
                lg: 'h-11 rounded-md px-8',
                icon: 'h-10 w-10',
            },
        },
        defaultVariants: {
            variant: 'default',
            size: 'default',
        },
    }
);

const buttonTextVariants = cva('text-sm font-medium', {
    variants: {
        variant: {
            default: 'text-white',
            destructive: 'text-white',
            outline: 'text-black',
            secondary: 'text-black',
            ghost: 'text-black',
            link: 'text-black underline',
        },
    },
    defaultVariants: {
        variant: 'default',
    },
});

interface ButtonProps
    extends React.ComponentPropsWithoutRef<typeof Pressable>,
    VariantProps<typeof buttonVariants> {
    label?: string;
    labelClasses?: string;
}

function Button({ className, variant, size, label, labelClasses, children, ...props }: ButtonProps) {
    return (
        <Pressable
            className={cn(buttonVariants({ variant, size, className }))}
            {...props}
        >
            {label ? (
                <Text className={cn(buttonTextVariants({ variant, className: labelClasses }))}>
                    {label}
                </Text>
            ) : (
                children
            )}
        </Pressable>
    );
}

export { Button, buttonVariants, buttonTextVariants };
