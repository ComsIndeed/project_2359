import { YStack, Text, Button, H1 } from 'tamagui';

export default function Index() {
    return (
        <YStack f={1} jc="center" ai="center" bg="$background" gap="$4">
            <H1>Hello Tamagui</H1>
            <Text fontSize="$6">Welcome to your new app!</Text>
            <Button theme="blue" size="$4">
                Get Started
            </Button>
        </YStack>
    );
}
