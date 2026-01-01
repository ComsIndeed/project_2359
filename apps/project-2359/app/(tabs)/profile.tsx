import { View, ScrollView, Switch } from 'react-native';
import { H2, H3, P, Muted, Large, Small } from '@/components/ui/typography';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Settings, User, Bell, Shield, LogOut, ChevronRight, Zap } from 'lucide-react-native';

export default function ProfileScreen() {
    return (
        <ScrollView className="flex-1 bg-white p-4">
            <View className="mt-12 mb-8 items-center">
                <View className="h-24 w-24 rounded-full bg-gray-100 items-center justify-center mb-4">
                    <User size={48} color="black" />
                </View>
                <H2>John Doe</H2>
                <Muted>Medical Student • Year 2</Muted>
            </View>

            <Card className="mb-6">
                <CardHeader>
                    <CardTitle className="text-lg">Study Activity</CardTitle>
                </CardHeader>
                <CardContent>
                    <View className="flex-row flex-wrap gap-1">
                        {Array.from({ length: 35 }).map((_, i) => (
                            <View
                                key={i}
                                className={`h-4 w-4 rounded-sm ${i % 7 === 0 ? 'bg-black' : i % 3 === 0 ? 'bg-gray-300' : 'bg-gray-100'
                                    }`}
                            />
                        ))}
                    </View>
                    <View className="flex-row justify-between mt-4">
                        <View className="items-center">
                            <Large>92%</Large>
                            <Small className="text-gray-500">Retention</Small>
                        </View>
                        <View className="items-center">
                            <Large>1.2k</Large>
                            <Small className="text-gray-500">Cards</Small>
                        </View>
                        <View className="items-center">
                            <Large>85</Large>
                            <Small className="text-gray-500">Predicted</Small>
                        </View>
                    </View>
                </CardContent>
            </Card>

            <View className="space-y-2">
                <H3 className="mb-2">Settings</H3>

                <View className="flex-row items-center justify-between p-4 bg-gray-50 rounded-xl mb-2">
                    <View className="flex-row items-center">
                        <Zap size={20} color="black" />
                        <P className="ml-3">Exam Mode</P>
                    </View>
                    <Switch value={true} />
                </View>

                <Pressable className="flex-row items-center justify-between p-4 bg-gray-50 rounded-xl mb-2">
                    <View className="flex-row items-center">
                        <Bell size={20} color="black" />
                        <P className="ml-3">Notifications</P>
                    </View>
                    <ChevronRight size={20} color="gray" />
                </Pressable>

                <Pressable className="flex-row items-center justify-between p-4 bg-gray-50 rounded-xl mb-2">
                    <View className="flex-row items-center">
                        <Shield size={20} color="black" />
                        <P className="ml-3">Privacy & Data</P>
                    </View>
                    <ChevronRight size={20} color="gray" />
                </Pressable>

                <Button variant="ghost" className="justify-start px-4 py-4 mt-4">
                    <LogOut size={20} color="#ef4444" />
                    <P className="ml-3 text-red-500">Log Out</P>
                </Button>
            </View>
        </ScrollView>
    );
}

import { Pressable } from 'react-native';
