import * as React from 'react';
import { Text, type TextProps } from 'react-native';
import { cn } from '../../lib/utils';

const H1 = React.forwardRef<Text, TextProps>(({ className, ...props }, ref) => (
    <Text
        ref={ref}
        className={cn('text-4xl font-extrabold tracking-tight text-black lg:text-5xl', className)}
        {...props}
    />
));
H1.displayName = 'H1';

const H2 = React.forwardRef<Text, TextProps>(({ className, ...props }, ref) => (
    <Text
        ref={ref}
        className={cn('text-3xl font-semibold tracking-tight text-black first:mt-0', className)}
        {...props}
    />
));
H2.displayName = 'H2';

const H3 = React.forwardRef<Text, TextProps>(({ className, ...props }, ref) => (
    <Text
        ref={ref}
        className={cn('text-2xl font-semibold tracking-tight text-black', className)}
        {...props}
    />
));
H3.displayName = 'H3';

const H4 = React.forwardRef<Text, TextProps>(({ className, ...props }, ref) => (
    <Text
        ref={ref}
        className={cn('text-xl font-semibold tracking-tight text-black', className)}
        {...props}
    />
));
H4.displayName = 'H4';

const P = React.forwardRef<Text, TextProps>(({ className, ...props }, ref) => (
    <Text
        ref={ref}
        className={cn('text-base leading-7 text-black', className)}
        {...props}
    />
));
P.displayName = 'P';

const Large = React.forwardRef<Text, TextProps>(({ className, ...props }, ref) => (
    <Text
        ref={ref}
        className={cn('text-lg font-semibold text-black', className)}
        {...props}
    />
));
Large.displayName = 'Large';

const Small = React.forwardRef<Text, TextProps>(({ className, ...props }, ref) => (
    <Text
        ref={ref}
        className={cn('text-sm font-medium leading-none text-black', className)}
        {...props}
    />
));
Small.displayName = 'Small';

const Muted = React.forwardRef<Text, TextProps>(({ className, ...props }, ref) => (
    <Text
        ref={ref}
        className={cn('text-sm text-gray-500', className)}
        {...props}
    />
));
Muted.displayName = 'Muted';

export { H1, H2, H3, H4, P, Large, Small, Muted };
