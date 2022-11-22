import React from 'react';
import {
  Box,
  Burger,
  Button,
  Center,
  Divider,
  Drawer,
  Group,
  Header,
  HoverCard,
  ScrollArea,
  UnstyledButton,
} from '@mantine/core';
import { MantineLogo } from '@mantine/ds';
import { useDisclosure } from '@mantine/hooks';
import Link from 'next/link';
import { Route } from '../AppHeader.constants';
import { useStyles } from './Navigation.styles';
import { signIn, signOut, useSession } from 'next-auth/react';

interface IProps {}

export const Navigation: React.FC<IProps> = (props) => {
  const { data: session } = useSession();
  const [drawerOpened, { toggle: toggleDrawer, close: closeDrawer }] =
    useDisclosure(false);
  const { classes, theme } = useStyles();

  return (
    <Box pb={120}>
      <Header height={60} px="md">
        <Group position="apart" sx={{ height: '100%' }}>
          <MantineLogo size={30} />
          <Group
            sx={{ height: '100%' }}
            spacing={0}
            className={classes.hiddenMobile}
          >
            <Link href={Route.Home} className={classes.link}>
              Home
            </Link>
            <HoverCard
              width={600}
              position="bottom"
              radius="md"
              shadow="md"
              withinPortal
            >
              <HoverCard.Target>
                <Link href={Route.Flights} className={classes.link}>
                  <Center inline>
                    <Box component="span" mr={5}>
                      Flights
                    </Box>
                  </Center>
                </Link>
              </HoverCard.Target>
            </HoverCard>
            <Link href={Route.Passengers} className={classes.link}>
              Passengers
            </Link>
            <Link href={Route.Schedule} className={classes.link}>
              Schedule
            </Link>
          </Group>

          <Group className={classes.hiddenMobile}>
            {!session && (
              <>
                <Button variant="default" onClick={() => signIn()}>
                  Log in
                </Button>
                <Link href={Route.Register}>
                  <Button>Sign up</Button>
                </Link>
              </>
            )}
            {session && (
              <Button variant="default" onClick={() => signOut()}>
                Log Out
              </Button>
            )}
          </Group>

          <Burger
            opened={drawerOpened}
            onClick={toggleDrawer}
            className={classes.hiddenDesktop}
          />
        </Group>
      </Header>

      <Drawer
        opened={drawerOpened}
        onClose={closeDrawer}
        size="100%"
        padding="md"
        title="Navigation"
        className={classes.hiddenDesktop}
        zIndex={1000000}
      >
        <ScrollArea sx={{ height: 'calc(100vh - 60px)' }} mx="-md">
          <Divider
            my="sm"
            color={theme.colorScheme === 'dark' ? 'dark.5' : 'gray.1'}
          />

          <Link href={Route.Home} className={classes.link}>
            Home
          </Link>

          <UnstyledButton className={classes.link}>
            <Center inline>
              <Box component="span" mr={5}>
                Flights
              </Box>
            </Center>
          </UnstyledButton>

          <Link href={Route.Passengers} className={classes.link}>
            Passengers
          </Link>

          <Link href={Route.Schedule} className={classes.link}>
            Schedule
          </Link>

          <Divider
            my="sm"
            color={theme.colorScheme === 'dark' ? 'dark.5' : 'gray.1'}
          />

          <Group position="center" grow pb="xl" px="md">
            {session && (
              <Button variant="default" onClick={() => signIn()}>
                Log in
              </Button>
            )}
            {!session && (
              <>
                <Button variant="default" onClick={() => signIn()}>
                  Log in
                </Button>
                <Link href={Route.Register}>
                  <Button>Sign up</Button>
                </Link>
              </>
            )}
          </Group>
        </ScrollArea>
      </Drawer>
    </Box>
  );
};

Navigation.displayName = 'Navigation';
